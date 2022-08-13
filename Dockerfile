FROM tensorflow/tensorflow:latest-gpu-jupyter
RUN apt-get install -y --no-install-recommends wget libgl1 libglib2.0-0 
# libglib2.0-0 ffmpeg 


RUN python -m pip install --upgrade pip
#this will downgrade to tensorflow to 2.6.
RUN pip install waymo-open-dataset-tf-2-6-0
#make keras version align with tensorflow
RUN pip install keras==2.6
#versions later than 0.16.1 would be not compatible with tf 2.6
RUN pip install tensorflow-addons==0.16.1

#install tensorflow object detection API and its dependencies
RUN pip install Cython 
RUN pip install -U git+https://github.com/philferriere/cocoapi.git#subdirectory=PythonAPI

RUN mkdir -p /app/protobuf && wget https://github.com/protocolbuffers/protobuf/releases/download/v3.13.0/protoc-3.13.0-linux-x86_64.zip && unzip protoc-3.13.0-linux-x86_64.zip -d /app/protobuf/ && rm  protoc-3.13.0-linux-x86_64.zip
ENV PATH "$PATH:/app/protobuf/bin"

#versions later than 2.5.1 would upgrade tensorflow to the latest version, which breaks the compatibility with waymo-open-dataset-tf-2-6-0
RUN pip install -U tf-models-official==2.5.1

RUN cd /app && \ 
    git clone https://github.com/tensorflow/models.git && \
    cd /app/models/research/ && \
    protoc object_detection/protos/*.proto --python_out=. && \
    cp object_detection/packages/tf2/setup.py . && \
    pip install -U  . 

RUN pip install jupyterlab
CMD [ "bash", "-c", "source /etc/bash.bashrc && jupyter lab --notebook-dir=/tf --ip 0.0.0.0 --no-browser --allow-root  --NotebookApp.token='' --NotebookApp.password=''"]
