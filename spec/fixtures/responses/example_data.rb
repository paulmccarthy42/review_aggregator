module ExampleData
  def self.expected_valid_lender_data
    {
      name: "First Midwest Bank",
      headline_numbers: {
        recommend_pct: 99,
        average_stars: 4.9,
        count_reviews: 1861,
        ratings_breakdown: {
          interest_rates_pct: 95.4,
          fees_and_closing_costs_pct: 93.2,
          responsiveness_pct: 98.6,
          customer_service_pct: 98.8
        }
      }
    }
  end

  def self.expected_valid_review_data
    [{:author=>"Karen",
     :content=>
      "Fast contact, easy document process, fast turn around and funds distribution. Contacting agent was professional and thorough without being overbearing ",
     :date=>"August 2019",
     :recommended=>true,
     :review_points=>
      {:closed_with_lender=>"Yes",
       :loan_type=>"Refinance",
       :review_type=>"Lender Review"},
     :stars=>5.0,
     :title=>"Fast, easy, professional service "},
    {:author=>"Therese",
     :content=>
      "Appreciated their persistence in reaching out to me without being overbearing. Answered all my questions and left the decision up to me, no undue pressure. Paying half the interest rate we were paying by consolidating our other credit cards with First Midwest Bank.<br>",
     :date=>"August 2019",
     :recommended=>true,
     :review_points=>
      {:closed_with_lender=>"Yes",
       :loan_type=>"Personal Loan",
       :review_type=>"Lender Review"},
     :stars=>5.0,
     :title=>"Very satisfied with our experience"},
    {:author=>"Dave",
     :content=>
      "I'd like to thank max, for giving me the opportunity, to consolidate, my bill's , it was a quick process, and good rates",
     :date=>"August 2019",
     :recommended=>true,
     :review_points=>
      {:closed_with_lender=>"Yes",
       :loan_type=>"Personal Loan",
       :review_type=>"Lender Review"},
     :stars=>5.0,
     :title=>"it. was a good experience"},
    {:author=>"Whitney",
     :content=>
      "My experience with First Midwest Bank was fantastic. Patrick and the rest of the team made the process simple and took time to answer all my questions. I wish I would have found them a long time ago. I highly recommend this establishment. ",
     :date=>"August 2019",
     :recommended=>true,
     :review_points=>
      {:closed_with_lender=>"Yes",
       :loan_type=>"Refinance",
       :review_type=>"Lender Review"},
     :stars=>5.0,
     :title=>"Fantastic Bank"},
    {:author=>"Mary",
     :content=>
      "An easy process and delivered in a timely manner. Chrissy Czarnecki was very efficient and easy tp talk to and she explained everything to me.",
     :date=>"August 2019",
     :recommended=>true,
     :review_points=>
      {:closed_with_lender=>"Yes",
       :loan_type=>"Debt Settlement/Credit Repair",
       :review_type=>"Lender Review"},
     :stars=>5.0,
     :title=>"Wonderful experience!"},
    {:author=>"Phong",
     :content=>
      "The entire process was really helpful and easy. Cassie was really helpful emailing me what i need in a matter of time. Through out the whole experience everything was good!",
     :date=>"August 2019",
     :recommended=>true,
     :review_points=>
      {:closed_with_lender=>"Yes",
       :loan_type=>"Personal Loan",
       :review_type=>"Lender Review"},
     :stars=>5.0,
     :title=>"Excellent services"},
    {:author=>"William",
     :content=>
      "Very prompt and efficient service.<br>Even when main contact was unavailable, back up support was just as good.",
     :date=>"August 2019",
     :recommended=>true,
     :review_points=>
      {:closed_with_lender=>"Yes",
       :loan_type=>"Personal Loan",
       :review_type=>"Lender Review"},
     :stars=>5.0,
     :title=>"Responsive service"},
    {:author=>"Sharon",
     :content=>
      "Excellent loan process. The intrest rate I received was awesome. I was able to pay off a high intrest rate credit for a much lower rate. The whole process only took a few days. Very satisfied with the service I received.",
     :date=>"August 2019",
     :recommended=>true,
     :review_points=>
      {:closed_with_lender=>"Yes",
       :loan_type=>"Personal Loan",
       :review_type=>"Lender Review"},
     :stars=>5.0,
     :title=>"Great and Prompt experince"},
    {:author=>"Lori",
     :content=>
      "Professionally handled. An easy experience and quick responses from start to finish. I would highly recommend to others.",
     :date=>"August 2019",
     :recommended=>true,
     :review_points=>
      {:closed_with_lender=>"Yes",
       :loan_type=>"Personal Loan",
       :review_type=>"Lender Review"},
     :stars=>5.0,
     :title=>"Simply an easy process!"},
    {:author=>"Diana",
     :content=>
      "The rep was so easy to work with. The process was so easy. Doing an on line loan was not stressful at all. It was made so simple. THANKS. ",
     :date=>"August 2019",
     :recommended=>true,
     :review_points=>
      {:closed_with_lender=>"Yes",
       :loan_type=>"Personal Loan",
       :review_type=>"Lender Review"},
     :stars=>5.0,
     :title=>"Loan"}]
  end

  def self.single_empty_review_data
    [{
      author: "",
      content: "",
      date: "",
      recommended: false,
      review_points: {},
      stars: 0.0,
      title: ""
    }]
  end

  def self.partial_review_data
    [{
      author: "",
      content: "",
      date: "",
      recommended: false,
      review_points: {},
      stars: 0.0,
      title: "Title"
    }]
  end
end