library(shiny)

shinyUI(pageWithSidebar(

     headerPanel(h2("Cousera Data Science: Capstone Project")),
     
     sidebarPanel(
          h3("Swiftkey Word Prediction"),
          p("Welcome to the web application for the Coursera's Data Science last part: 
            Capstone Project SwiftKey Word prediction."), br(),
          
          h4("Instructions"),
          
          h5("Input the text word by word in the left panel."),
          p("As well you add new words the algorithm will adapt for give you always 
            the next word prediction and several others candidates ordered in 
            descendent probability."),
          
          
          # Variable del texto
          textInput("text", "Input the text", value="hello"),
          
          # Palabras a sugerir
          numericInput("nsug", "N° of sugested words", 10, min=5, max=20),
          
          # Autor
          br(), br(), br(), br(), br(), br(), br(), br(), br(),
          p("Author: Oliver Rojas - Apr, 2016"),
          
     # submitButton("Submit"),
     width = 4),
     
## Panel de al lado ----------------------------------------------------------------
     mainPanel(      
          tabsetPanel(
          
          # Pestaña 1
          tabPanel("Prediction",
               h3("Results of the prediction algorithm"),
               p("The programmed algorithm will show the predicted next word and predict 
               a serveral words who rank best for your next word"),
               
               # El texto ingresado 
               h4("You have been write"),
               verbatimTextOutput("textOut"),

               # Number of predicted words
               # p("Your requested number of suggestions"),
               # verbatimTextOutput("nsugOUT")
               
               # Predicted word
               h4("Your next predicted word is:"),
               verbatimTextOutput("nextword"),
               
               # Suggestions
               h4("Next suggested words"),
               verbatimTextOutput("plusword")
          ),
          
          # Pestaña 2
          tabPanel("Algorithm",
               
               # How the algorithm works
               h4("How the algorithm works"),
               p("This is a simple explanation in words of how the algorithm works, it's an example of a given
                 4 words text. Supose you need 8 alternatives for the next word prediction."), 
               
               HTML("The text is:"),
               strong("Well ... See you later :)"),
               
               HTML("<br><br>First pre-proccess the text <br>"),
               
               HTML("<b>1.-</b> Take the text given and clean it: <b>well see you later</b><br>"), 
               HTML("<b>2.-</b> Tokenize it and count: <b>well, see, you, later</b>, n=4 <br><br>"),
               
               HTML("Search for predicted word<br>"),
               HTML("<b>3.-</b> Given n=4 words I will seach these four word sequence in the first four words
                    of 5-gram object.<br>
                    Supose I find 4 suggested words ordered by probability. Like I said, we need
                    8 possible words, so I need to keep looking for.<br><br>"),
               
               HTML("The recursive part<br>"),
               HTML("<b>4.-</b> I will cut the original 4-Word sentence by the left, so now I have a
                    3-Word sentence already clean and tokenized <b>see, you, later</b> <br>"),
               HTML("<b>5.-</b> Now I will use the new 3-Word sentence to search any match in the 4-Gram and append it
                    to the search performed above <br>"),
               HTML("<b>6.-</b> If I still not complete the numbers of suggested words needed, I'll run again
                    the point 3 and 4 and so on, until there is no words too look for and the only way is to use
                    the 1-gram to complete the number of suggested words<br><br>"),
               
               HTML("Of course in each step I exclude the words already finded, and a lot of other things, so the algorith
                    can work properly<br> I cut a part of the algorithm who find association of 
                    the sugested words and the corpus of the given text because it work too slow. <br><br><br>")
          ),
          
          # Tab: Resources
          tabPanel("Resources",
                   h3("Resources"),
                   p("Here you can find all the resources used to build this app"),
                   br(),
                   
                   strong("Slide Deck presentation"), 
                   a("https://translate.google.cl"), br(), br(),
                   
                   strong("R packages used"),
                   p("stringi for clean, quanteda for n-gram construction, dplyr for data management, ggplot2
                     in the milestone project"),
                   
                   strong("Other resources"),
                   p("Rpresentation to build the SliceDeck, Shiny package and ShinyApps to mount the app"),
                   
                   strong("GitHub Account"),
                   a("https://github.com/olitroski/Capstone")
          )
          
          
     ))
     
         
)
)

