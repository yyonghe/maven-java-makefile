
ifndef PROJECT_DIR
PROJECT_DIR = ../../..
endif

ifndef TARGET_DIR
TARGET_DIR = $(PROJECT_DIR)/target
endif

EXTLIB_DIR = $(PROJECT_DIR)/src/main/native/extlib

ARCH=$(shell uname -m)
TARGET_LIB_NAME:=$(shell cat $(PROJECT_DIR)/src/main/resources/META-INF/jniloader.txt)

OBJ_DIR = $(TARGET_DIR)/obj
LIB_DIR = $(TARGET_DIR)/classes/META-INF

CC = g++
LD = g++
CFLAGS += -g -O2 -D_REENTRANT -DUSE_THREADS -D_THREAD_SAFE -D_GNU_SOURCE -DNEED_FILTER -DNEED_XSS -fPIC
CFLAGS += -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(EXTLIB_DIR)/include  
LDFLAGS += -shared

ALL_CFLAGS = 
LDLIBS = 
EXT_LDFLAGS = 

DYN_MODULES=
LIB_DIRS=
################check cpp
cppcode:=$(shell ls *.cpp 2>/dev/null 1>/dev/null; echo $$?)
ifeq ($(cppcode),0)
CPPs:=$(shell ls *.cpp)
else
CPPs=
endif
################check c
ccode:=$(shell ls *.c 2>/dev/null 1>/dev/null; echo $$?)
ifeq ($(ccode),0)
Cs:=$(shell ls *.c)
else
Cs=
endif
#######32 mode
DYN_MODULES += $(LIB_DIR)/32/$(TARGET_LIB_NAME)
LIB_DIRS += $(LIB_DIR)/32
LIB_OBJS_32=
####check cpp
ifeq ($(cppcode),0)
CPP_OBJs_32:=$(shell for name in $(CPPs) ; do echo $${name} | awk -F"." '{print "$(OBJ_DIR)/32/cpp/"$$1".o "}'; done)
else
CPP_OBJs_32=
endif
LIB_OBJS_32 += $(CPP_OBJs_32)
####check c
ifeq ($(ccode),0)
C_OBJs_32:=$(shell for name in $(Cs) ; do echo $${name} | awk -F"." '{print "$(OBJ_DIR)/32/c/"$$1".o "}'; done)
else
C_OBJs_32=
endif
LIB_OBJS_32+=$(C_OBJs_32)
#######64 mode
ifeq ($(ARCH),x86_64)
DYN_MODULES += $(LIB_DIR)/64/$(TARGET_LIB_NAME)
LIB_DIRS += $(LIB_DIR)/64
LIB_OBJS_64=
####check cpp
ifeq ($(cppcode),0)
CPP_OBJs_64:=$(shell for name in $(CPPs) ; do echo $${name} | awk -F"." '{print "$(OBJ_DIR)/64/cpp/"$$1".o "}'; done)
else
CPP_OBJs_64=
endif
LIB_OBJS_64 += $(CPP_OBJs_64)
####check c
ifeq ($(ccode),0)
C_OBJs_64:=$(shell for name in $(Cs) ; do echo $${name} | awk -F"." '{print "$(OBJ_DIR)/64/c/"$$1".o "}'; done)
else
C_OBJs_64=
endif
LIB_OBJS_64 += $(C_OBJs_64)
endif
           
.PHONY: clean

debug opt: $(OBJ_DIR) $(LIB_DIRS) $(DYN_MODULES) 

$(OBJ_DIR):
	-@mkdir -p $(OBJ_DIR)/32/cpp
	-@mkdir -p $(OBJ_DIR)/32/c
	-@mkdir -p $(OBJ_DIR)/64/cpp
	-@mkdir -p $(OBJ_DIR)/64/c

$(LIB_DIRS):
	-@mkdir -p $(LIB_DIR)/32
	-@mkdir -p $(LIB_DIR)/64


$(OBJ_DIR)/32/c/%.o: %.c
	-gcc -m32 -c -o $@ $(CFLAGS) $(ALL_CFLAGS) $<

$(OBJ_DIR)/32/cpp/%.o: %.cpp
	-$(CC) -m32 -c -o $@ $(CFLAGS) $(ALL_CFLAGS) $<

$(OBJ_DIR)/64/c/%.o: %.c
	-gcc -c -o $@ $(CFLAGS) $(ALL_CFLAGS) $<

$(OBJ_DIR)/64/cpp/%.o: %.cpp
	-$(CC) -c -o $@ $(CFLAGS) $(ALL_CFLAGS) $<

$(LIB_DIR)/32/$(TARGET_LIB_NAME): $(LIB_OBJS_32)
	-$(LD) $(LDFLAGS) -m32 -o $@ $(LIB_OBJS_32) -L $(EXTLIB_DIR)/lib/32 $(EXT_LDFLAGS)

$(LIB_DIR)/64/$(TARGET_LIB_NAME): $(LIB_OBJS_64)
	-$(LD) $(LDFLAGS) -o $@ $(LIB_OBJS_64) -L $(EXTLIB_DIR)/lib/64  $(EXT_LDFLAGS)

clean:
	-@rm -rf $(LIB_DIR) $(OBJ_DIR)
