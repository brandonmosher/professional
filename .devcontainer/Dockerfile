From texlive/texlive:latest

COPY json_to_tex json_to_tex

RUN wget https://raw.githubusercontent.com/brandonmosher/devcontainer-base/main/utils/apt-install.sh && \
    chmod +x apt-install.sh && \
    ./apt-install.sh fonts-font-awesome python3-pip && \
    pip install ./json_to_tex


