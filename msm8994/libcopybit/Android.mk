# Copyright (C) 2008 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH:= $(call my-dir)
include $(LOCAL_PATH)/../common.mk

include $(CLEAR_VARS)
LOCAL_COPY_HEADERS_TO         := $(common_header_export_path)
LOCAL_COPY_HEADERS            := copybit.h copybit_priv.h c2d2.h
include $(BUILD_COPY_HEADERS)

include $(CLEAR_VARS)
# b/24171136 many files not compiling with clang/llvm yet
LOCAL_CLANG := false

LOCAL_MODULE                  := copybit.$(TARGET_BOARD_PLATFORM)
LOCAL_LICENSE_KINDS           := SPDX-license-identifier-Apache-2.0 SPDX-license-identifier-BSD legacy_not_a_contribution
LOCAL_LICENSE_CONDITIONS      := by_exception_only not_allowed notice
LOCAL_NOTICE_FILE             := $(LOCAL_PATH)/NOTICE
LOCAL_MODULE_RELATIVE_PATH    := hw
LOCAL_PROPRIETARY_MODULE      := true
LOCAL_MODULE_TAGS             := optional
LOCAL_C_INCLUDES              := $(common_includes) $(kernel_includes)
LOCAL_SHARED_LIBRARIES        := $(common_libs) libdl libmemalloc
LOCAL_CFLAGS                  := $(common_flags) -DLOG_TAG=\"qdcopybit\"
LOCAL_ADDITIONAL_DEPENDENCIES := $(common_deps)

ifeq ($(TARGET_USES_C2D_COMPOSITION),true)
    LOCAL_CFLAGS += -DCOPYBIT_Z180=1 -DC2D_SUPPORT_DISPLAY=1
    LOCAL_SRC_FILES := copybit_c2d.cpp software_converter.cpp
    include $(BUILD_SHARED_LIBRARY)
else
    ifneq ($(call is-chipset-in-board-platform,msm7630),true)
        ifneq (,$(call is-board-platform-in-list2,$(MSM7K_BOARD_PLATFORMS)))
            LOCAL_CFLAGS += -DCOPYBIT_MSM7K=1
            LOCAL_SRC_FILES := software_converter.cpp copybit.cpp
            include $(BUILD_SHARED_LIBRARY)
        endif
        ifneq (,$(call is-board-platform-in-list2, msm8610 msm8909))
            LOCAL_SRC_FILES := software_converter.cpp copybit.cpp
            include $(BUILD_SHARED_LIBRARY)
        endif
    endif
endif