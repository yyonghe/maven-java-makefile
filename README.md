maven-java-makefile
===================

maven-java-makefile


compile $(PROJECT_DIR)/src/main/native
.c -> .o
.cpp -> .o

and than
*.o -> TARGET_LIB_NAME.so

TARGET_LIB_NAME is defined in file $(PROJECT_DIR)/src/main/resources/META-INF/jniloader.txt

so file will be located in target/classes/META-INF/32/xx.so

Others, if you are currently compiling on 64 bit system, a 64 bit so will be created in
target/classes/META-INF/64/xx.so