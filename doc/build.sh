

echo "gitbook build "
dirname=$(pwd)
echo "${dirname}"

docker run  --name "wfyGitBook"  -v ${dirname}:/srv/gitbook --rm dotopt/gitbook-cli gitbook install



docker run  --name "wfyGitBook"  -v ${dirname}:/srv/gitbook --rm dotopt/gitbook-cli gitbook build


mv ./_book  ../360club.github.io/doc

