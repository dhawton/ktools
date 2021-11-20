#!/bin/sh

mkdir -p ~/.ssh
echo $SSH_KEY | base64 -d > ~/.ssh/id_ecdsa
chmod 600 ~/.ssh/id_ecdsa
chmod 700 ~/.ssh
ssh-keyscan $MANIFEST_HOST >> ~/.ssh/known_hosts

if [[ -d $MANIFEST_REPO ]]; then
    rm -rf $MANIFEST_REPO
fi

git clone git@${MANIFEST_HOST}/${MANIFEST_USER}/${MANIFEST_REPO}.git

cd $MANIFEST_REPO
git checkout $MANIFEST_BRANCH
cd $KUSTOMIZE_PATH

for IMG in $(echo $IMAGE | sed "s/,/ /g"); do
    kustomize edit set image $IMG=${IMG}:${IMAGE_TAG}
done

git add .
git commit --allow-empty -m "Update image tags"
git push git@${MANIFEST_HOST}/${MANIFEST_USER}/${MANIFEST_REPO}.git $MANIFEST_BRANCH