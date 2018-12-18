FROM centos:7

# Download essentials for the following commands.
RUN yum update -y && \
	yum -y install wget tar && \
	yum clean all

# Download and install newer gcc compiler.
RUN yum -y install centos-release-scl && \
	yum -y install devtoolset-7-toolchain && \
	yum -y install gcc && \
	yum -y install gcc-c++ && \
	scl enable devtoolset-7 bash && \
	yum clean all

# Download and install latest cmake.
RUN yum -y install cmake
# RUN mkdir -p /tmp/cmake_download && \
# 	pushd /tmp/cmake_download && \
# 	wget -nv 'https://cmake.org/files/v3.10/cmake-3.10.2-Linux-x86_64.sh' && \
# 	bash cmake-3.10.2-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir && \
# 	popd && \
# 	rm -rf /tmp/cmake_download

# Download and install openssl
RUN yum -y install openssl && \
	yum -y install openssl-libs

# Download and install libcurl
RUN yum -y install libcurl && \
	yum -y install libcurl-devel

# Download and install libxml2
RUN yum -y install libxml2 && \
	yum -y install libxml2-devel

RUN yum clean all

COPY ./ /build-temp/
WORKDIR /build-temp/
RUN cmake ./
RUN make
RUN make install

FROM centos:7

COPY --from=0 /usr/local/share/locale/fr/LC_MESSAGES/madeline2.mo /usr/local/share/locale/fr/LC_MESSAGES/madeline2.mo
COPY --from=0 /usr/local/share/locale/th/LC_MESSAGES/madeline2.mo /usr/local/share/locale/th/LC_MESSAGES/madeline2.mo
COPY --from=0 /usr/local/share/locale/zh_CN/LC_MESSAGES/madeline2.mo /usr/local/share/locale/zh_CN/LC_MESSAGES/madeline2.mo
COPY --from=0 /usr/local/share/locale/zh_TW/LC_MESSAGES/madeline2.mo /usr/local/share/locale/zh_TW/LC_MESSAGES/madeline2.mo
COPY --from=0 /usr/local/docs/AUTHORS /usr/local/docs/AUTHORS
COPY --from=0 /usr/local/bin/madeline2 /usr/local/bin/madeline2
COPY --from=0 /build-temp/entrypoint /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint
ENTRYPOINT [ "/usr/local/bin/entrypoint" ]