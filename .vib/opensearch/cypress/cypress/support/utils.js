/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

/// <reference types="cypress" />

export let random = (Math.floor(Math.random() * 10000) + 10000)
  .toString()
  .substring(1);
