#pragma once
#include <config.h>
#include <module.h>
#include <module_com.h>
#include "command_args.h"
#include <atomic>

#ifdef __APPLE__
#define GL_SILENCE_DEPRECATION
#endif


namespace core {
    SDRPP_EXPORT ConfigManager configManager;
    SDRPP_EXPORT ModuleManager moduleManager;
    SDRPP_EXPORT ModuleComManager modComManager;
    SDRPP_EXPORT CommandArgsParser args;

    void setInputSampleRate(double samplerate);

    constexpr int NARGUMENTS = 20000;
    struct SpawnCommand {
        char executable[500];
        char args[10][500];
        int nargs;
        char outPath[500];
        char errPath[500];
        int completeStatus;
        std::atomic_bool completed = false;
        char info[50];
        int pid;
        int seq;
    };

    SDRPP_EXPORT bool forkIt(const std::shared_ptr<SpawnCommand> &cmd);
    SDRPP_EXPORT void removeForkInProgress(int seq);

};

#ifdef __linux__
#include <sys/prctl.h>
#endif
inline void SetThreadName(const std::string &threadName)
{
#ifdef __linux__
    prctl(PR_SET_NAME,threadName.c_str(),0,0,0);
#endif
}
inline std::string GetThreadName( ) {
#ifdef __linux__
    char thread_name_buffer[100] = { 0 };
    prctl(PR_GET_NAME,thread_name_buffer,0,0,0);
    return std::string(thread_name_buffer);
#endif
    return "??";
}

SDRPP_EXPORT char* sdrppResourcesDirectory; // to reference from C files.


int sdrpp_main(int argc, char* argv[]);