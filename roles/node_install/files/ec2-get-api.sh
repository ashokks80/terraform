#!/bin/bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
APIGATEWAY=${aws apigatewayv2 get-apis --region us-east-1|grep -i https|grep -E -o 'https://\w+.execute-api.us-east-1.amazonaws.com'}
export $APIGATEWAY
echo "$APIGATEWAY URL THIS IS"
