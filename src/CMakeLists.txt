include_directories(
    ../src
    ../build
    ../depends/json/single_include)

link_libraries(${GMP_LIB})

add_definitions(${GMP_DEFINIONS})

if(USE_ASM)
    if(ARCH MATCHES "arm64")
            add_definitions(-DUSE_ASM -DARCH_ARM64)
    elseif(ARCH MATCHES "x86_64")
            add_definitions(-DUSE_ASM -DARCH_X86_64)
    endif()
endif()

if(USE_ASM AND ARCH MATCHES "x86_64")

    if (CMAKE_HOST_SYSTEM_NAME MATCHES "Darwin")
        set(NASM_FLAGS -fmacho64 --prefix _)
    else()
        set(NASM_FLAGS -felf64 -DPIC)
    endif()

    add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/build/fq_asm.o
        COMMAND nasm ${NASM_FLAGS} fq.asm -o fq_asm.o
        DEPENDS ${CMAKE_SOURCE_DIR}/build/fq.asm
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/build)

    add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/build/fr_asm.o
        COMMAND nasm ${NASM_FLAGS} fr.asm -o fr_asm.o
        DEPENDS ${CMAKE_SOURCE_DIR}/build/fr.asm
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/build)
endif()

set(FR_SOURCES
    ../build/fr.hpp
    ../build/fr.cpp
    )

if(USE_ASM)
    if(ARCH MATCHES "arm64")
        set(FR_SOURCES ${FR_SOURCES} ../build/fr_raw_arm64.s ../build/fr_raw_generic.cpp ../build/fr_generic.cpp)
    elseif(ARCH MATCHES "x86_64")
        set(FR_SOURCES ${FR_SOURCES} ../build/fr_asm.o)
    endif()
else()
    set(FR_SOURCES ${FR_SOURCES} ../build/fr_generic.cpp ../build/fr_raw_generic.cpp)
endif()

add_library(fr STATIC ${FR_SOURCES})
set_target_properties(fr PROPERTIES POSITION_INDEPENDENT_CODE ON)

link_libraries(fr)


add_executable(tests tests.cpp)
add_executable(test_platform test_platform.cpp)


set(LIB_SOURCES
    calcwit.cpp
    witnesscalc.h
    witnesscalc.cpp
    )

# authV2
set(AUTHV2_SOURCES ${LIB_SOURCES}
    authV2.cpp
    witnesscalc_authV2.h
    witnesscalc_authV2.cpp
    )

add_library(witnesscalc_authV2 SHARED ${AUTHV2_SOURCES})
add_library(witnesscalc_authV2Static STATIC ${AUTHV2_SOURCES})
set_target_properties(witnesscalc_authV2Static PROPERTIES OUTPUT_NAME witnesscalc_authV2)

add_executable(authV2 main.cpp)
target_link_libraries(authV2 witnesscalc_authV2Static)

target_compile_definitions(witnesscalc_authV2 PUBLIC CIRCUIT_NAME=authV2)
target_compile_definitions(witnesscalc_authV2Static PUBLIC CIRCUIT_NAME=authV2)
target_compile_definitions(authV2 PUBLIC CIRCUIT_NAME=authV2)

# aadhaar_verifier
set(AADHAARVERIFIER_SOURCES ${LIB_SOURCES}
    aadhaar_verifier.cpp
    witnesscalc_aadhaar_verifier.h
    witnesscalc_aadhaar_verifier.cpp
    )

add_library(witnesscalc_aadhaar_verifier SHARED ${AADHAARVERIFIER_SOURCES})
add_library(witnesscalc_aadhaar_verifierStatic STATIC ${AADHAARVERIFIER_SOURCES})
set_target_properties(witnesscalc_aadhaar_verifierStatic PROPERTIES OUTPUT_NAME witnesscalc_aadhaar_verifier)

add_executable(aadhaar_verifier main.cpp)
target_link_libraries(aadhaar_verifier witnesscalc_aadhaar_verifierStatic)

target_compile_definitions(witnesscalc_aadhaar_verifier PUBLIC CIRCUIT_NAME=aadhaar_verifier)
target_compile_definitions(witnesscalc_aadhaar_verifierStatic PUBLIC CIRCUIT_NAME=aadhaar_verifier)
target_compile_definitions(aadhaar_verifier PUBLIC CIRCUIT_NAME=aadhaar_verifier)
