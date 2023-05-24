# Security Release Process

The community has adopted this security disclosure and response policy to ensure we responsibly handle critical issues.


## Supported Versions

For a list of support versions that this project will potentially create security fixes for, please refer to the Releases page on this project's GitHub and/or project related documentation on release cadence and support.


## Reporting a Vulnerability - Private Disclosure Process

Security is of the highest importance and all security vulnerabilities or suspected security vulnerabilities should be reported to this project privately, to minimize attacks against current users  before they are fixed. Vulnerabilities will be investigated and patched on the next patch (or minor) release as soon as possible. This information could be kept entirely internal to the project.

If you know of a publicly disclosed security vulnerability for this project, please **IMMEDIATELY** contact the maintainers of this project privately. The use of encrypted email is encouraged.


**IMPORTANT: Do not file public issues on GitHub for security vulnerabilities**

To report a vulnerability or a security-related issue, please contact the maintainers with enough details through one of the following channels: 
* Directly via their individual email addresses
* Open a [GitHub Security Advisory](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing/privately-reporting-a-security-vulnerability). This allows for anyone to report security vulnerabilities directly and privately to the maintainers via GitHub. Note that this option may not be present for every repository.

The report will be fielded by the maintainers who have committer and release permissions. Feedback will be sent within 3 business days, including a detailed plan to investigate the issue and any potential workarounds to perform in the meantime. 

Do not report non-security-impacting bugs through this channel. Use GitHub issues for all non-security-impacting bugs.


## Proposed Report Content

Provide a descriptive title and in the description of the report include the following information:

*   Basic identity information, such as your name and your affiliation or company.
*   Detailed steps to reproduce the vulnerability  (POC scripts, screenshots, and logs are all helpful to us).
*   Description of the effects of the vulnerability on this project and the related hardware and software configurations, so that the maintainers can reproduce it.
*   How the vulnerability affects this project's usage and an estimation of the attack surface, if there is one.
*   List other projects or dependencies that were used in conjunction with this project to produce the vulnerability.


## When to report a vulnerability

*   When you think this project has a potential security vulnerability.
*   When you suspect a potential vulnerability but you are unsure that it impacts this project.
*   When you know of or suspect a potential vulnerability on another project that is used by this project.


## Patch, Release, and Disclosure

The maintainers will respond to vulnerability reports as follows:

1. The maintainers will investigate the vulnerability and determine its effects and criticality.
2. If the issue is not deemed to be a vulnerability, the maintainers will follow up with a detailed reason for rejection.
3. The maintainers will initiate a conversation with the reporter within 3 business days.
4. If a vulnerability is acknowledged and the timeline for a fix is determined, the maintainers will work on a plan to communicate with the appropriate community, including identifying mitigating steps that affected users can take to protect themselves until the fix is rolled out.
5. The maintainers will also create a [Security Advisory](https://docs.github.com/en/code-security/repository-security-advisories/publishing-a-repository-security-advisory) using the [CVSS Calculator](https://www.first.org/cvss/calculator/3.0), if it is not created yet.  The maintainers make the final call on the calculated CVSS; it is better to move quickly than making the CVSS perfect. Issues may also be reported to [Mitre](https://cve.mitre.org/) using this [scoring calculator](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator). The draft advisory will initially be set to private.
6. The maintainers will work on fixing the vulnerability and perform internal testing before preparing to roll out the fix.
7. Once the fix is confirmed, the maintainers will patch the vulnerability in the next patch or minor release, and backport a patch release into all earlier supported releases.


## Public Disclosure Process

The maintainers publish the public advisory to this project's community via GitHub. In most cases, additional communication via Slack, Twitter, mailing lists, blog, and other channels will assist in educating the project's users and rolling out the patched release to affected users.

The maintainers will also publish any mitigating steps users can take until the fix can be applied to their instances. This project's distributors will handle creating and publishing their own security advisories.


## Confidentiality, integrity and availability

We consider vulnerabilities leading to the compromise of data confidentiality, elevation of privilege, or integrity to be our highest priority concerns. Availability, in particular in areas relating to DoS and resource exhaustion, is also a serious security concern. The maintainer team takes all vulnerabilities, potential vulnerabilities, and suspected vulnerabilities seriously and will investigate them in an urgent and expeditious manner.

Note that we do not currently consider the default settings for this project to be secure-by-default. It is necessary for operators to explicitly configure settings, role based access control, and other resource related features in this project to provide a hardened environment. We will not act on any security disclosure that relates to a lack of safe defaults. Over time, we will work towards improved safe-by-default configuration, taking into account backwards compatibility.
