FROM ubuntu
# Use bash instead of sh! (so we can use the source command)
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Download `add-apt-repository`
RUN apt-get update && apt-get install software-properties-common --yes

# 3.2.1 thru 3.2.3
# Update gcc
RUN add-apt-repository ppa:ubuntu-toolchain-r/test && apt-get update && \
  apt install gcc-6 g++-6 --yes

# 3.2.4
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 \
  --slave /usr/bin/g++ g++ /usr/bin/g++-6

ENV WORKSPACE /home/ubuntu/workspace
# 3.3.1
RUN mkdir -p ${WORKSPACE}/langr-book
WORKDIR ${WORKSPACE}
#
# # 3.3.2 - 3.3.3
RUN cd ${WORKSPACE}/langr-book && \
  apt-get install curl && curl -o lotdd-code.tgz \
  http://media.pragprog.com/titles/lotdd/code/lotdd-code.tgz && \
  tar -xf lotdd-code.tgz

# 3.4.1 - 3.4.4
RUN mkdir ${WORKSPACE}/testing-frameworks && \
  apt-get install git cmake --yes && \
  git clone https://github.com/google/googletest ${WORKSPACE}/testing-frameworks/googletest && \
  mkdir ${WORKSPACE}/testing-frameworks/googletest/mybuild && \
  cd $WORKSPACE/testing-frameworks/googletest/mybuild && \
  cmake .. && make

# 3.4.5
ENV GTEST_DIR ${WORKSPACE}/testing-frameworks/googletest/googletest

# 3.4.6
RUN cd ${GTEST_DIR}/make && make && ./sample1_unittest

# 3.4.7
ENV PATH="$PATH:\"$GTEST_DIR/include\""

# 3.5.1 - 3.5.2
ENV GMOCK_DIR ${WORKSPACE}/testing-frameworks/googletest/googlemock
ENV GMOCK_HOME ${GMOCK_DIR}

# 3.5.3
RUN cd ${GMOCK_DIR}/make && make && ./gmock_test

# 3.5.4 - 3.5.5
RUN cd ${GMOCK_DIR} && ln -s ${GTEST_DIR} gtest && ln -s make mybuild

# 3.5.6 - 3.5.7
RUN cd ${GMOCK_DIR}/mybuild && ar -rv libgmock.a gtest-all.o gmock-all.o && \
  mkdir ${GMOCK_DIR}/gtest/mybuild && cd ${GMOCK_DIR}/gtest/mybuild && \
  cmake .. && make

# 3.5.8
RUN mkdir ${WORKSPACE}/langr-book/code/c2/40/build && \
  cd ${WORKSPACE}/langr-book/code/c2/40/build && cmake .. -Wno-dev && make && ./test

# 3.5.9
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:\"$GMOCK_DIR/mybuild\""

# 3.6.1 - 3.6.2
RUN cd ${WORKSPACE}/testing-frameworks && git clone git://github.com/cpputest/cpputest.git

# 3.6.3
ENV CPPUTEST_HOME /home/ubuntu/workspace/testing-frameworks/cpputest

# 3.6.4 - 3.6.5
RUN cd ${GMOCK_HOME} && cmake . && make && cd ${CPPUTEST_HOME} && \
  apt-get install dh-autoreconf --yes && ./autogen.sh && ./configure && make

# 3.6.6, keeping this in just for debugging
RUN mkdir ${WORKSPACE}/3.6.6_test
COPY 3.6.6_test.c ${WORKSPACE}/3.6.6_test/test.c
RUN cd ${WORKSPACE}/3.6.6_test && g++ ./test.c -I $CPPUTEST_HOME/include -L \
  $CPPUTEST_HOME/lib -l CppUTest -l CppUTestExt && ./a.out

# 3.7.1
RUN curl -o curl.tar.gz https://curl.haxx.se/download/curl-7.53.1.tar.gz && \
  tar -xf curl.tar.gz && mv curl-7.53.1 lib && rm -f curl.tar.gz

# 3.7.2
ENV CURL_HOME ${WORKSPACE}/lib

# 3.7.3
RUN apt-get install libssl-dev --yes && cd ${CURL_HOME} && mkdir build && cd build && \
  cmake .. && make

# 3.8.1
RUN cd ${WORKSPACE} && curl -o boost.tar.gz \
  https://superb-dca2.dl.sourceforge.net/project/boost/boost/1.63.0/boost_1_63_0.tar.gz && \
  tar -xf boost.tar.gz && rm -f boost.tar.gz

ENV BOOST_ROOT ${WORKSPACE}/boost_1_63_0

RUN cd ${BOOST_ROOT} && ./bootstrap.sh --with-libraries=filesystem,system && ./b2

# 4.1 was performed in 3.5.8 already
# 4.2
RUN mkdir ${WORKSPACE}/langr-book/code/c3/18/build && \
  cd ${WORKSPACE}/langr-book/code/c3/18/build && cmake .. -Wno-dev && make && ./test

# 4.3
RUN mkdir ${WORKSPACE}/langr-book/code/c6/19/build && \
  cd ${WORKSPACE}/langr-book/code/c6/19/build && cmake .. -Wno-dev && make && ./test

# Now create a place for our code!
RUN mkdir ${WORKSPACE}/p1
COPY p1 ${WORKSPACE}/p1
