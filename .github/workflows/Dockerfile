FROM emscripten/emsdk:latest

RUN apt update
RUN apt install -y bison
RUN embuilder.py build libpng zlib --lto
RUN embuilder.py build MINIMAL --lto