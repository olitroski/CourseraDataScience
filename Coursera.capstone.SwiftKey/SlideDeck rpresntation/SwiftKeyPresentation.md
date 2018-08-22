Data Science Capstone    SwiftKey Word Prediction
========================================================
author: Oliver Rojas     
date: April, 2016
autosize: false
transition: rotate



Overview
========================================================

This is the presentation for Coursera's Data Science last part: **SwiftKey Capstone Project**, an interactive web application built in ShinyApps, consisting of a custom natural language processing model to predict the next word of a given text, based on an analysis of a large corpus. 

The goal of this project can be resumed in five parts.
- Data aquisition and Understanding the data
- Model creation
- Build the Shiny App
- Slide Deck


Model creation
========================================================

The original corpus for this project consist of 3 raw text files, which comes from blogs, twitter and news (about 580MB). 

The data was cleaned (**stringi package**), tokenized and a several n-gram objects was builted (**quanteda package**) in levels from one to five. This construct was tabulated in order to get the probability the word apperance each n-gram file.

Finally an algorithm was develop in order to select the next prediction word based in the amount of words given and their probability in the largest n-gram and back to `n-1` gram if no matches were found.


Prediction Algorithm
========================================================

A prediction algorithm was develop based on the Kat's Back-off model, where the conditional probability of a word is estimated based on the context of the preceding words. Each n-gram object was ordered based on the raw probability and using proper filters was applied in order to get the most probable next word.  

<small>
**Example: For a given text of 4 words:**  
**1 -** Search for match in the first *4* words of *5-gram* object and select **n** most probable words.  
**2 -** If the **n** words selected are less than *10* (for example), cut a word of a given text by the left, so we have *3* words now.  
**3 -** Search for match in the first *3* words of *4-gram* object and select **n** most probable words.  
**4 -** If the **n** words selected are less than the requiered amount of predicted words: Repeat the steps in *2 -> 3*  until the *1-gram* object.
</small>


Shiny Application
========================================================
The interactive web application was hosted at **shiny.io** and can be tested in this link: https://olitroski.shinyapps.io/CapstoneProject/

1. Input the text word by word in the left panel

2. For every word you write, you will see in the main panel three results:  
     + The entire text you had tiping
     + The predicted word
     + The next **n** more words probable words
     
<small>
Because the limitations of shiny or my lack of expertice, I didn't find a way to put the predicted word direct into your text, so you have to tipe one of the sugestions.
</small>


Resources Used
========================================================

The following tools was used in this project.
<small>
* Most of the code was written in **RKWard Gui for R**
* Cleaning of the original text was prerformed using **stringi package**
* For n-gram construction I used **quanteda package**
* For general tabulation **dplyr package**
* For plots in the exploatory section **ggplot2 package**
* **RStudio** for build and publish this presentation using **R Presentations**
* **shiny package** and *ShinyApps* via **RStudio** to develop the web application of my algorithm.
</small>

























