Auto compile java-jni project to so libriry on Linux using Maven
===================

compile $(PROJECT_DIR)/src/main/native
.c -> .o
.cpp -> .o

And than
*.o -> TARGET_LIB_NAME.so

TARGET_LIB_NAME is defined in file $(PROJECT_DIR)/src/main/resources/META-INF/jniloader.txt

.so files will be located in $(PROJECT_DIR)/target/classes/META-INF/32/xx.so

Others, if you are currently compiling on 64 bit system, a 64 bit .so files will be created in
$(PROJECT_DIR)/target/classes/META-INF/64/xx.so
