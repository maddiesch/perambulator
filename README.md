# Perambulator

### Required Permissions

```json
{
	"Version": "2012-10-17",
	"Statement": [{
			"Effect": "Allow",
			"Action": [
				"ssm:GetParameters"
			],
			"Resource": "arn:aws:ssm:*:*:parameter/perambulator/*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"kms:Encrypt",
				"kms:Decrypt",
				"kms:ReEncrypt*",
				"kms:GenerateDataKey*",
				"kms:DescribeKey"
			],
			"Resource": "arn:aws:kms:*:*:key/da2150d0-fe73-4260-95d8-9d8aa5cc1d6f"
		}
	]
}
```
