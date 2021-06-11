# Overview
Being part of the Application Moderinsation practice at Google, we often face into a discussion around how would Google build a _state of the art_, modern application on [GCP][1].

As you would expect, this discussion is always nuanced.  Few of the variables in this context are:  
1. Starting position or the current technology stack that customer/partner is looking to modernise
2. Available skill set
3. Regulations imposed by the particular customer industry vertical
4. Status of [cloud foundation][2]
5. Risk appetite of the business
6. Cost
7. And many, many, many more that we haven't listed here

This exercise is an attempt to describe a _specific path_ on the application modernisation journey while highlighting various other alternatives.  Idea is to have a writeup for every step accompanied by a code sample.  So we will build on an existing foundation (or examples) when discussing a specific topic.  
Most important aim of this exercise is to learn along the way.  This work is based on our experience of working with our stakeholders, and we hope to incorporate your feedback into this work.

## This is meant to be technical writeup, but...
Adoption of cloud is not a sequential or linear path, but a constant journey of learning.  Successfull teams exhibit following four behaviours:
1. Focus on [validation instead of verification][3]: this means getting the product into the hands of the customer as early as possible
   > Verification: are we building the product right?  
   > Validation: are we building the right product?
2. Experiment and iterate: building a functional prototype is prioritised over designing for corner cases and end-state
3. Scalability: onboarding new customers, without further _significant_ investment in build and operate functions
4. Adaptable: ability to change path and use new technology with minimum friction

## Starting Position
For the purpose of this exercise, we will use the functionality provided by [Bank of Anthos][6] application as a reference point.  
Idea is that _The Bank of Anthos_ is a workload hosted on virtual machines on-prem.  And we want to migrate it to cloud using following guidelines:
1. Use a managed service where possible
2. Identify the metric to measure change

## Software lifecycle
We will consider three broad phases of software lifecylce:
1. Design time: focus on building an effective, functional system
2. Deploy time: focus on [automating deployment pipeline][4]
   - Deployment frequency
   - Lead time for changes
   - Change failure rate
   - Time to restore service
3. Run time: focus on [four golden signals][5] of monitoring
   - Latency
   - Traffic
   - Errors
   - Saturation
  
Initially we will focus on the design and deploy time considerations.

# The Journey
1. Containerise the workload hosted on virtual machines
2. _Gradually_ migrate functionality to a Kubernetes platform
3. How to direct (ingress) traffic to the containerised workload?

-----
[1]: https://cloud.google.com/
[2]: https://cloud.google.com/foundation-toolkit
[3]: https://en.wikipedia.org/wiki/Software_verification_and_validation
[4]: https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance
[5]: https://sre.google/sre-book/monitoring-distributed-systems/#xref_monitoring_golden-signals
[6]: https://github.com/GoogleCloudPlatform/bank-of-anthos