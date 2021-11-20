FROM line/kubectl-kustomize:1.22.4-4.4.1

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV SSH_KEY=
ENV IMAGE=
ENV IMAGE_TAG=
ENV MANIFEST_HOST=
ENV MANIFEST_PORT=
ENV MANIFEST_REPO=
ENV MANIFEST_BRANCH=
ENV KUSTOMIZE_PATH=

ENTRYPOINT ["/entrypoint.sh"]