---
inclusion: always
---

# CLI Tools and SDK Inventory

## Core Principle

**ALWAYS use available CLI tools and SDKs directly. DO NOT ask the user to run commands manually unless:**
- The command requires interactive input that cannot be automated
- The command is a long-running process (dev servers, watchers)
- The command requires credentials you cannot access through other means

**For everything else, just run the command.**

## Available Tools

### Version Control
- **git** (v2.23.0)
  - Location: `/usr/local/bin/git`
  - Use for: commits, branches, status, diffs, logs, remote operations
  - Run directly: `git status`, `git log`, `git diff`, etc.

### Python Ecosystem
- **python3** (v3.11.5)
  - Location: `/usr/local/bin/python3`
  - Use for: running scripts, testing, package management
  - Run directly: `python3 script.py`, `python3 -m module`

- **pip3** (v23.2.1)
  - Location: `/usr/local/bin/pip3`
  - Use for: installing packages, listing dependencies
  - Run directly: `pip3 install package`, `pip3 list`, `pip3 freeze`

- **alembic** (v1.11.2)
  - Location: `/Users/alexpatton/miniconda3/bin/alembic`
  - Use for: database migrations
  - Run directly: `alembic upgrade head`, `alembic revision --autogenerate -m "message"`

### Node.js Ecosystem
- **node** (v25.3.0)
  - Location: `/Users/alexpatton/.nvm/versions/node/v25.3.0/bin/node`
  - Use for: running JavaScript, testing
  - Run directly: `node script.js`

- **npm** (v11.6.2)
  - Location: `/Users/alexpatton/.nvm/versions/node/v25.3.0/bin/npm`
  - Use for: installing packages, running scripts, building
  - Run directly: `npm install`, `npm test`, `npm run build`

### Database
- **psql** (PostgreSQL 14.20)
  - Location: `/usr/local/bin/psql`
  - Use for: database queries, schema inspection, data operations
  - Run directly: `psql -h host -U user -d database -c "SELECT * FROM table"`
  - Can connect to local or remote databases

- **redis-cli** (v8.6.1)
  - Location: `/usr/local/bin/redis-cli`
  - Use for: Redis operations, cache inspection, key management
  - Run directly: `redis-cli KEYS pattern`, `redis-cli GET key`

### Cloud & Infrastructure
- **aws** (aws-cli/2.34.2)
  - Location: `/usr/local/bin/aws`
  - Configured: Yes (credentials in `~/.aws/credentials`, region: us-east-1)
  - Use for: S3, EC2, RDS, CloudWatch, CodePipeline, Lambda, etc.
  - Run directly: `aws s3 ls`, `aws ec2 describe-instances`, `aws logs tail`
  - **DO NOT ask for AWS credentials** - they're already configured

- **terraform** (v1.14.5)
  - Location: `/usr/local/bin/terraform`
  - Use for: infrastructure provisioning, state management
  - Run directly: `terraform plan`, `terraform apply`, `terraform state list`

### Containers
- **docker** (v24.0.5)
  - Location: `/usr/local/bin/docker`
  - Note: Docker daemon may not always be running
  - Use for: container management, image operations
  - Run when daemon is up: `docker ps`, `docker logs`, `docker exec`

### Python Packages (Available via python3 -m)
- **boto3** (v1.42.61) - AWS SDK for Python
  - Use for: programmatic AWS access in Python scripts
  - Run: `python3 -c "import boto3; client = boto3.client('s3'); print(client.list_buckets())"`

## Common Use Cases

### Database Operations
```bash
# Check database schema
psql -h localhost -U username -d database_name -c "\dt"

# Run migration
alembic upgrade head

# Check migration status
alembic current
```

### AWS Operations
```bash
# List S3 buckets
aws s3 ls

# Check CloudWatch logs
aws logs tail /aws/lambda/function-name --follow

# Describe EC2 instances
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,Tags[?Key==`Name`].Value|[0]]' --output table

# Check CodePipeline status
aws codepipeline list-pipelines
aws codepipeline get-pipeline-execution --pipeline-name name --pipeline-execution-id id
```

## Environment Naming Convention

**Critical:** When the user says "develop" or "development", they mean the **deployed development environment** (AWS/cloud). When they say "local", they mean the instance running on their local machine. These are never interchangeable:

| User says | Means |
|---|---|
| `develop` / `development` | Deployed dev environment (AWS) |
| `staging` | Deployed staging environment (AWS) |
| `production` / `prod` | Deployed production environment (AWS) |
| `local` | Local machine instance |

When diagnosing issues in `develop`, use AWS tools (CloudWatch logs, ECS/EC2, RDS, ElastiCache) — not local log files or local DB connections.

---

## Package Management
```bash
# Python packages
pip3 list
pip3 show package-name

# Node packages
npm list --depth=0
npm outdated
```

## What NOT to Do

❌ Don't say: "You can run `aws s3 ls` to check your buckets"
✅ Instead: Run `aws s3 ls` and show the results

❌ Don't say: "Run `git status` to see what changed"
✅ Instead: Run `git status` and analyze the output

❌ Don't say: "You'll need to run the migration with `alembic upgrade head`"
✅ Instead: Run `alembic upgrade head` and report the results

❌ Don't ask: "What's your AWS access key?"
✅ Instead: Use the configured AWS CLI directly

## Exceptions (When to Ask User)

1. **Long-running processes**: `npm start`, `python main.py` (dev servers)
2. **Interactive commands**: Text editors, interactive prompts
3. **Destructive operations requiring confirmation**: `terraform destroy`, `DROP DATABASE`
4. **Commands requiring passwords not available through other means**

For everything else, just run it.
