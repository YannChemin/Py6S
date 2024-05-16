FROM debian:stable
#ENV DEBIAN_FRONTEND=noninteractive
ENV TERM xterm
# Set ENV for x11 display
#ENV DISPLAY $DISPLAY
#ENV QT_X11_NO_MITSHM 1
ENV DISPLAY :0

ENV LC_ALL C.UTF-8
USER root
RUN echo "deb https://fr.debian.org/debian stable main contrib non-free non-free-firmware" > /etc/apt/sources.list

# Install.
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get dist-upgrade -y
RUN apt-get install -y apt wget build-essential
RUN apt-get install -y man git gfortran
RUN apt-get install -y python3-minimal python3-setuptools 
RUN apt-get install -y python3-venv 
 
# Clean up the mess
RUN apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/*

# Create USER
RUN useradd --create-home --shell /bin/bash py6s
#RUN echo 'yann:newpassword' | chpasswd
USER py6s
WORKDIR /home/py6s

# Create the Python Virtual Env
RUN python3 -m venv /home/py6s/py6s
RUN /home/py6s/py6s/bin/python3 -m pip install --upgrade pip setuptools
RUN wget -c https://files.pythonhosted.org/packages/cc/56/ceef9c8c12600a1ceb3dcefdd9e5094c72fbdba0c3af785b4a69205022c1/bunch-1.0.1.zip
RUN /home/py6s/py6s/bin/pip install /home/py6s/bunch-1.0.1.zip 
RUN /home/py6s/py6s/bin/pip install solar --no-cache 
RUN /home/py6s/py6s/bin/pip install python-dateutil --no-cache
RUN /home/py6s/py6s/bin/pip install mock --no-cache

WORKDIR /home/py6s
# Get the whole thing
RUN git clone https://github.com/YannChemin/Py6s
# Compile and install 6sV2.1
WORKDIR /home/py6s/Py6s/6s
RUN make
RUN make install
# Build the Python Wrapper
WORKDIR /home/py6s/Py6s
RUN /home/py6s/py6s/bin/python3 ./setup.py build
RUN /home/py6s/py6s/bin/python3 ./setup.py install



# Define default command.
CMD ["bash"]
#RUN /home/AROSIS/miniforge3/condabin/conda activate arosics
#RUN bash arosics
#ENV DEBIAN_FRONTEND=teletype
