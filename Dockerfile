FROM centos:centos8

#COPY requirements.txt /requirements.txt
RUN yum check-update;

#ENTRYPOINT ["hello"]
CMD ["/bin/bash"]