# README

The API built out here is fairly simple. 

* It has a single endpoint: `/api/v1/reviews`

* It takes one required parameter - `base_url` - and one optional parameter - `page_count`

* `base_url` must match the format for a lender's review page on LendingTree, which is `https://www.lendingtree.com/reviews/:loan_type/:lender_slug/:lender_id`. The protocol must be spelled out explicitly at the beginning of the parameter

* If the URL is the right shape, and links to a valid review page, the API will return the following information on that lender:
** Lender name
** Percent of users who recommend lender
** Average star rating, as well as breakdown of specific ratings for lender subcategories (APR, Customer Service, etc.)
** Data from the ten most recent reviews left for that lender, including title, content, author, star rating, recommendation and date submitted

* if an integer is provided for `page_count` in the API call, the API will try to load that many pages worth of reviews (i.e., `page_count=1` will load 10 reviews, `page_count=5` will load 50)
