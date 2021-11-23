#!/bin/sh

function chkfail() {
  if [ $? -ne 0 ]; then
    echo "Failed ($?)"
    exit 1
  fi
}

echo "machine github.com login $GH_USER password $GH_TOKEN" > ~/.netrc

git config --global user.email $GH_USER_EMAIL
git config --global user.name $GH_USER_NAME

if [[ -d $MANIFEST_REPO ]]; then
    rm -rf $MANIFEST_REPO
fi

git clone https://${MANIFEST_HOST}/${MANIFEST_USER}/${MANIFEST_REPO}
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
git push https://${MANIFEST_HOST}/${MANIFEST_USER}/${MANIFEST_REPO} $MANIFEST_BRANCH
chkfail
