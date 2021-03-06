# Copyright (C) 2009-2014 MongoDB, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

Feature: Replica Set Connection
  In order to support changes to the state of a replica set
  As a driver author
  I want to verify that the driver correctly behaves according to documentation and specification
  http://docs.mongodb.org/manual/reference/command/nav-replication/
  https://github.com/mongodb/specifications/tree/master/source/server-discovery-and-monitoring

  @reset
  Scenario: Discovery from Primary Seed
    Given a replica set with preset arbiter
    And a document written to all data-bearing members
    And I stop the arbiter
    And I stop the secondary
    And a replica-set client with a seed from the primary
    When I query with retries and read-preference SECONDARY
    Then the query succeeds
    When I start the arbiter
    And I query with retries and read-preference PRIMARY
    Then the query succeeds
    When I start the secondary
    And I query with retries and read-preference SECONDARY
    Then the query succeeds

  @reset
  Scenario: Discovery from Secondary Seed
    Given a replica set with preset arbiter
    And a document written to all data-bearing members
    And I stop the arbiter
    And I stop the primary
    And a replica-set client with a seed from the secondary
    When I query with read-preference SECONDARY
    Then the query succeeds
    When I start the arbiter
    And I query with retries and read-preference PRIMARY
    Then the query succeeds
    When I start the primary
    And I query with retries and read-preference SECONDARY
    Then the query succeeds

  @reset
  Scenario: Discovery from Arbiter Seed
    Given a replica set with preset arbiter
    And a document written to all data-bearing members
    And I stop the primary
    And a replica-set client with a seed from the arbiter
    And I query with retries and read-preference PRIMARY
    Then the query succeeds
    When I start the primary
    And I query with retries and read-preference SECONDARY
    Then the query succeeds

  @reset
  Scenario: Insert with Primary Step Down
    Given a replica set with preset arbiter
    When I insert a document
    Then the insert succeeds
    When I command the primary to step down
    And I insert a document with retries
    Then the insert succeeds

  @reset
  Scenario: Query with Primary Step Down Query
    Given a replica set with preset arbiter
    And a document written to all data-bearing members
    And I query
    Then the query succeeds
    When I command the primary to step down
    And I query with retries
    Then the query succeeds

  @reset
  Scenario: Insert with Primary Stop, Start and Restart
    Given a replica set with preset arbiter
    When I insert a document
    Then the insert succeeds
    When I stop the primary
    And I insert a document with retries
    Then the insert succeeds
    When I start the primary
    And I insert a document with retries
    Then the insert succeeds
    When I restart the primary
    And I insert a document with retries
    Then the insert succeeds

  @reset
  Scenario: Query with Primary Stop, Start and Restart
    Given a replica set with preset arbiter
    And a document written to all data-bearing members
    And I query
    Then the query succeeds
    When I stop the primary
    And I query with retries
    Then the query succeeds
    When I start the primary
    And I query with retries
    Then the query succeeds
    When I restart the primary
    And I query with retries
    Then the query succeeds
