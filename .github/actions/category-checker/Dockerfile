FROM quay.io/helmpack/chart-testing:v2.4.1

RUN wget https://github.com/mikefarah/yq/releases/download/3.3.2/yq_linux_amd64 && \
    chmod +x yq_linux_amd64 && \
    mv yq_linux_amd64 /usr/local/bin/yq

COPY .github/category-checker/ct-check-category.yaml /ct-config.yaml
COPY .github/category-checker/category-checker.sh /category-checker.sh

ENTRYPOINT ["/category-checker.sh"]
