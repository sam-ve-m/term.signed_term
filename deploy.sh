fission spec init
fission env create --spec --name term-of-user-get-env --image nexus.sigame.com.br/fission-term-of-user-get:0.1.0-0 --poolsize 0 --version 3 --imagepullsecret "nexus-v3" --spec
fission fn create --spec --name term-of-user-get-fn --env term-of-user-get-env --code fission.py --targetcpu 80 --executortype newdeploy --maxscale 3 --requestsperpod 10000 --spec
fission route create --spec --name term-of-user-get-rt --method GET --url /term/signed --function term-of-user-get-fn