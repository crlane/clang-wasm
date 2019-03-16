DEPS = 
OBJ = library.o
NANOLIBC_OBJ = $(patsubst %.cpp,%.o,$(wildcard nanolibc/*.cpp))
OUTPUT = library.wasm

COMPILE_FLAGS = -Wall \
		--target=wasm32 \
		-Os \
		-flto \
		-nostdlib \
		-fvisibility=hidden \
		-std=c++14 \
		-ffunction-sections \
		-fdata-sections
		

$(OUTPUT): $(OBJ) $(NANOLIBC_OBJ) Makefile
	wasm-ld-8 \
		-o $(OUTPUT) \
		--no-entry \
		--strip-all \
		--export-dynamic \
		--initial-memory=131072 \
		-error-limit=0 \
		--lto-O3 \
		-O3 \
		--gc-sections \
		$(OBJ) \
		$(LIBCXX_OBJ) \
		$(NANOLIBC_OBJ)


%.o: %.cpp $(DEPS) Makefile
	clang++-8 \
		-c \
		$(COMPILE_FLAGS) \
		-o $@ \
		$<

library.wat: $(OUTPUT) Makefile
	~/build/wabt/wasm2wat -o library.wat $(OUTPUT)

wat: library.wat

clean:
	rm -f $(OBJ) $(LIBCXX_OBJ) $(OUTPUT) library.wat
