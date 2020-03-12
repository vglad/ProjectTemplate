FROM vglad/centos8:gcc9

#COPY requirements.txt /requirements.txt
RUN yum upgrade;

#ENTRYPOINT ["hello"]
#CMD ["uname"]