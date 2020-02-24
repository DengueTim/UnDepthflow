FROM tensorflow/tensorflow:1.2.1-gpu
RUN apt-get update
RUN apt-get install -y python-tk
RUN apt install -y libsm6 libxext6
RUN pip install --upgrade pip
RUN pip install opencv-python
RUN pip install pypng
RUN pip install scikit-image
RUN groupadd -g 1000 tp
RUN useradd -ms /bin/bash -u 1000 -g 1000 tp
USER tp
CMD bash
