Feature: Merge Articles
  As a blog administrator
  In order to merge articles into one
  I want to be able to merge one article to another

  Background:
    Given the blog is set up
    And the following users exist:
    | login | password  | profile_id  | state   | email             |
    | user1 | password  | 2           | active  | email1@domain.com |
    | user2 | password  | 2           | active  | email2@domain.com |
    And the following articles exist:
    | user  | author    | title   | body    | state     |
    | user1 | Author 1  | Title 1 | Body 1  | published |
    | user2 | Author 2  | Title 2 | Body 2  | published |
    And the following comments exist:
    | article | comment   | author    |
    | Title 1 | Comment 1 | Author 3  |
    | Title 1 | Comment 2 | Author 4  |
    | Title 2 | Comment 3 | Author 5  |

  Scenario: A non-admin cannot merge articles
    Given I am logged in as "user1"
    And I am editing article "Title 1"
    Then I should not see "Merge Articles"

  Scenario: When articles are merged, the merged article should contain the text of both previous articles
    Given I am logged into the admin panel
    And I am editing article "Title 1"
    And I fill in "merge_with" with article "Title 2"'s id
    And I press "Merge"
    Then a new article new_article is created
    And new_article should contain the followings: "Body 1", "Body 2"

  Scenario: When articles are merged, the merged article should have one author (either one of the authors of the two original articles)
    Given I am logged into the admin panel
    And I am editing article "Title 1"
    And I fill in "merge_with" with article "Title 2"'s id
    And I press "Merge"
    Then a new article new_article is created
    And new_article's author should be one of the followings: "Author 1", "Author 2"

  Scenario: Comments on each of the two original articles need to all carry over and point to the new, merged article
    Given I am logged into the admin panel
    And I am editing article "Title 1"
    And I fill in "merge_with" with article "Title 2"'s id
    And I press "Merge"
    Then a new article new_article is created
    And new_article should have the following comments: "Comment 1", "Comment 2", "Comment 3"

  Scenario: The title of the new article should be the title from either one of the merged articles
    Given I am logged into the admin panel
    And I am editing article "Title 1"
    And I fill in "merge_with" with article "Title 2"'s id
    And I press "Merge"
    Then a new article new_article is created
    And new_article's title should be one of the followings: "Title 1", "Title 2"