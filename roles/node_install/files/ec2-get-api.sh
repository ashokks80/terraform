#!/bin/bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
apigatewayurl=`aws apigatewayv2 get-apis --region us-east-1|grep -i https|grep -E -o 'https://\w+.execute-api.us-east-1.amazonaws.com'`
apigateway_url=$apigatewayurl
echo $apigateway_url
echo "API_GATEWAY_URL=${apigateway_url}" > ~/.bashrc
touch .env
echo "API_GATEWAY_URL=${apigateway_url}" > .env
echo "$apigateway_url URL THIS IS"
npm install dotenv --save
aws s3 cp s3://crud-s3-testing-api/node_code /tmp
exit 0
