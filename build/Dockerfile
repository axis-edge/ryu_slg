FROM python:3.7.7-buster
RUN git clone https://github.com/lagopus/ryu-lagopus-ext && \
    cd ryu-lagopus-ext && \
    git checkout lagopus-general-tunnel-ext && \
    python3 ./setup.py install 
COPY . .
RUN pip3 install -r requirements.txt

ENTRYPOINT ["ryu-manager", "ryu_slg.py", "ryu_slg_init.py"]

