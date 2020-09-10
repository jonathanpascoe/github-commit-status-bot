#!/usr/bin/env bash

AWS_DEFAULT_PROFILE=${AWS_DEFAULT_PROFILE:-enview-engineering}
S3_BUCKET=${S3_BUCKET:-"codepipeline-status-artifacts-engineering"}
INPUT_FILE=template.yaml
OUTPUT_FILE=template-output.yaml
REGION=${AWS_DEFAULT_REGION:-us-west-2}
STACK_NAME=github-commit-status-bot

cd src && npm install && npm run-script lint && npm test && npm prune --production && cd ..

aws cloudformation package --template-file $INPUT_FILE --s3-bucket $S3_BUCKET --output-template-file $OUTPUT_FILE
aws cloudformation deploy --template-file $OUTPUT_FILE --stack-name $STACK_NAME --capabilities CAPABILITY_NAMED_IAM --region $REGION
