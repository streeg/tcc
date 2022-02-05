from github import Github
import pandas as pd

# First create a Github instance:

# using an access token
g = Github("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")

# Github Enterprise with custom hostname
# g = Github(base_url="https://{hostname}/api/v3", login_or_token="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")

# Then play with your Github objects:
# for repo in g.get_user().get_repos():
#     print(repo.name)
#     repo.create_issue(title="This is a new test issue",
#                       body="This is the issue test body")


df_ = pd.read_csv('FilteredCryptoAndroidReport.csv')
print(df.to_string())

# Firefly III Mobile Version:
# 4.14.2
# I'm a PhD student exploring the state-of-the-art of Static Analysis tools for detecting vulnerabilities due to crypto-API misuses.
# This issue has not been generated automatically.

# I have detected 35 warnings that reveal possible incorrect usages of the JCA library on FireflyMobile (or its library dependencies). I documented these issues in private gists for the sake of non disclosure.
# How should I proceed to share these issues? I hope we can evaluate the severity of these warnings and thus improve the FireflyMobile security.

# The tool that I have used for the analysis is: CogniCrypt
