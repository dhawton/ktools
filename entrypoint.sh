#!/bin/sh

function chkfail() {
  if [ $? -ne 0 ]; then
    echo "Failed ($?)"
    exit 1
  fi
}

mkdir -p ~/.ssh
echo $SSH_KEY | base64 -d > ~/.ssh/id_ecdsa
chkfail

ls -l ~/.ssh/id_ecdsa
chmod 600 ~/.ssh/id_ecdsa
chmod 700 ~/.ssh
ssh-keyscan $MANIFEST_HOST >> ~/.ssh/known_hosts
chkfail

if [[ -d $MANIFEST_REPO ]]; then
    rm -rf $MANIFEST_REPO
fi

git clone git@${MANIFEST_HOST}:${MANIFEST_USER}/${MANIFEST_REPO}.git
chkfail

cd $MANIFEST_REPO
git checkout $MANIFEST_BRANCH
chkfail
cd $KUSTOMIZE_PATH

for IMG in $(echo $IMAGE | sed "s/,/ /g"); do
    kustomize edit set image $IMG=${IMG}:${IMAGE_TAG}
    chkfail
done

git add .
chkfail
git commit --allow-empty -m "Update image tags"
chkfail
git push git@${MANIFEST_HOST}:${MANIFEST_USER}/${MANIFEST_REPO}.git $MANIFEST_BRANCH
chkfail