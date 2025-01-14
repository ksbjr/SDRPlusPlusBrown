#pragma once
#include "../processor.h"
#include "../taps/tap.h"
#include <utils/flog.h>

namespace dsp::filter {
    template <class D, class T>
    class FIR : public Processor<D, D> {
        using base_type = Processor<D, D>;
    public:
        FIR() {}

        FIR(stream<D>* in, tap<T>& taps) { init(in, taps); }

        ~FIR() {
            if (!base_type::_block_init) { return; }
            base_type::stop();
            buffer::free(buffer);
        }

        virtual void init(stream<D>* in, tap<T>& taps) {
            _taps = taps;

            // Allocate and clear buffer
            buffer = buffer::alloc<D>(STREAM_BUFFER_SIZE + 64000);
            bufStart = &buffer[_taps.size - 1];
            buffer::clear<D>(buffer, _taps.size - 1);
//            spdlog::info("FIR: Allocated buffer of size {0} at {1}", STREAM_BUFFER_SIZE + 64000, (void*)buffer);

            base_type::init(in);
        }

        virtual void setTaps(tap<T>& taps) {
            assert(base_type::_block_init);
            std::lock_guard<std::recursive_mutex> lck(base_type::ctrlMtx);
            base_type::tempStop();

            int oldTC = _taps.size;
            _taps = taps;

            // Update start of buffer
            bufStart = &buffer[_taps.size - 1];

            // Move existing data to make transition seemless
            if (_taps.size < oldTC) {
                memcpy(buffer, &buffer[oldTC - _taps.size], (_taps.size - 1) * sizeof(D));
            }
            else if (_taps.size > oldTC) {
                memcpy(&buffer[_taps.size - oldTC], buffer, (oldTC - 1) * sizeof(D));
                buffer::clear<D>(buffer, _taps.size - oldTC);
            }
            
            base_type::tempStart();
        }

        virtual void reset() {
            assert(base_type::_block_init);
            std::lock_guard<std::recursive_mutex> lck(base_type::ctrlMtx);
            base_type::tempStop();
            buffer::clear<D>(buffer, _taps.size - 1);
            base_type::tempStart();
        }

        inline int process(int count, const D* in, D* out) {
            // Copy data to work buffer
            memcpy(bufStart, in, count * sizeof(D));

            // Do convolution
            for (int i = 0; i < count; i++) {
                if constexpr (std::is_same_v<D, float> && std::is_same_v<T, float>) {
                    volk_32f_x2_dot_prod_32f(&out[i], &buffer[i], _taps.taps, _taps.size);
                } else if constexpr ((std::is_same_v<D, complex_t>) && std::is_same_v<T, float>) {
                    volk_32fc_32f_dot_prod_32fc((lv_32fc_t*)&out[i], (lv_32fc_t*)&buffer[i], _taps.taps, _taps.size);
                } else  if constexpr ((std::is_same_v<D, complex_t> || std::is_same_v<D, stereo_t>) && (std::is_same_v<T, complex_t>)) {
                    volk_32fc_x2_dot_prod_32fc((lv_32fc_t*)&out[i], (lv_32fc_t*)&buffer[i], (lv_32fc_t*)_taps.taps, _taps.size);
                } else if constexpr (std::is_same_v<D, stereo_t> && std::is_same_v<T, float_t>) {
                  volk_32f_x2_dot_prod_32f(&out[i].l, &buffer[i].l, _taps.taps, _taps.size);
                  volk_32f_x2_dot_prod_32f(&out[i].r, &buffer[i].r, _taps.taps, _taps.size);
                } else {
                  static_assert((D)0, "type error"); // compile-time error
                }
            }

            // Move unused data
            auto nmove = (_taps.size - 1) * sizeof(D);
            memmove(buffer, &buffer[count], nmove);

            if (Processor<D, D>::out.outputHook) {
                Processor<D, D>::out.outputHook(out, count);
            }
            return count;
        }

        virtual int run() {
            int count = base_type::_in->read();
            if (count < 0) { return -1; }

            process(count, base_type::_in->readBuf, base_type::out.writeBuf);

            base_type::_in->flush();
            if (!base_type::out.swap(count)) { return -1; }
            return count;
        }

    protected:
        tap<T> _taps;
        D* buffer;
        D* bufStart;
    };
}