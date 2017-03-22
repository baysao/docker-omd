FROM phusion/baseimage:0.9.19

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]



ENV DEBIAN_FRONTEND noninteractive

RUN  echo 'net.ipv6.conf.default.disable_ipv6 = 1' > /etc/sysctl.d/20-ipv6-disable.conf; \
    echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.d/20-ipv6-disable.conf; \
    echo 'net.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.d/20-ipv6-disable.conf; \
    cat /etc/sysctl.d/20-ipv6-disable.conf; sysctl -p

RUN apt-get update && \
    apt-get install -y lsof vim git openssh-server tree tcpdump libevent-2.0-5

RUN gpg --keyserver keys.gnupg.net --recv-keys F8C1CA08A57B9ED7 && gpg --armor --export F8C1CA08A57B9ED7 | apt-key add - && \
    echo "deb http://labs.consol.de/repo/testing/ubuntu $(cat /etc/lsb-release | grep DISTRIB_CODENAME | cut -d'=' -f2) main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y omd-labs-edition-daily &&  \
    apt-get clean


ADD omd.sh /etc/service/omd/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


