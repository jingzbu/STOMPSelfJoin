#Make sure that this points to the cuda install you want to use
CUDA_DIRECTORY=/usr/local/cuda
CC=$(CUDA_DIRECTORY)/bin/nvcc
#Volta
ARCH=-gencode=arch=compute_70,code=sm_70
#Pascal
#ARCH=-gencode=arch=compute_60,code=sm_60

CFLAGS=-c -use_fast_math -lineinfo -O2 -std=c++11 $(ARCH) -I$(CUDA_DIRECTORY)/include

#If you want to use the matlab hook, please specify the compute capability of your GPU below
MATLABARCH=-gencode=arch=compute_60,code=sm_60
MATFLAGS=-ptx -src-in-ptx -use_fast_math -lineinfo -std=c++11 $(MATLABARCH) -O2 -I$(CUDA_DIRECTORY)/include
LDFLAGS=-L$(CUDA_DIRECTORY)/lib64 -lcufft
SOURCES=STOMP.cu
HEADERS=STOMP.h
OBJECTS=STOMP.o
EXECUTABLE=STOMP

all: $(SOURCES) $(EXECUTABLE)

best: $(SOURCES) $(BESTEX)

matlab: $(SOURCES) $(HEADERS)
	$(CC) $(MATFLAGS) $(SOURCES)
    
$(EXECUTABLE): $(OBJECTS)  $(SOURCES) $(HEADERS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
	
STOMP.o: $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) STOMP.cu -o $@
	
clean:
	rm -f *.o STOMP
