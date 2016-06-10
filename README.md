# elasticsearch

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)

## Overview

This module uses the puppet elasticsearch module to build members of an elasticsearch
cluster with appropriate configuration.

## Module Description

This module will try to configure a three member elasticsearc master cluster with
all other members either being data nodes or clients. The master nodes will not
also be data nodes and the data nodes will not be master nodes. This decision was
made to ensure the cluster is as stable as possible.
