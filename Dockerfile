FROM gcc
RUN apt-get update && apt-get install -y cmake \
	libssl-dev \
	# libcurl-dev \
	libxml2-dev

RUN apt-get install -y gettext \
	gettext-lint

RUN apt-get install -y inkscape \
	doxygen

COPY ./ /build-temp/
WORKDIR /build-temp/
RUN cmake ./
RUN make
RUN make install

FROM debian:stretch

COPY --from=0 /usr/local/share/locale/fr/LC_MESSAGES/madeline2.mo /usr/local/share/locale/fr/LC_MESSAGES/madeline2.mo
COPY --from=0 /usr/local/share/locale/th/LC_MESSAGES/madeline2.mo /usr/local/share/locale/th/LC_MESSAGES/madeline2.mo
COPY --from=0 /usr/local/share/locale/zh_CN/LC_MESSAGES/madeline2.mo /usr/local/share/locale/zh_CN/LC_MESSAGES/madeline2.mo
COPY --from=0 /usr/local/share/locale/zh_TW/LC_MESSAGES/madeline2.mo /usr/local/share/locale/zh_TW/LC_MESSAGES/madeline2.mo
COPY --from=0 /usr/local/docs/AUTHORS /usr/local/docs/AUTHORS
COPY --from=0 /usr/local/bin/madeline2 /usr/local/bin/madeline2
COPY --from=0 /build-temp/entrypoint /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint
ENTRYPOINT [ "/usr/local/bin/entrypoint" ]