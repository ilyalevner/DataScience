

library(dplyr)

#### On Windows:
library(DBI)
con <- dbConnect(odbc::odbc(), .connection_string = "DSN=COLLEGE;Trusted_Connection=yes;", timeout = 10)


library(DBI)
con <- dbConnect(odbc::odbc(), "college", timeout = 10)
sql <- "SELECT * FROM COLLEGE.dbo.Students"
stu <- dbGetQuery(con, "SELECT * FROM COLLEGE.dbo.Students")
cur <- dbGetQuery(con, "SELECT * FROM COLLEGE.dbo.Courses")
Dep <- dbGetQuery(con, "SELECT * FROM COLLEGE.dbo.Departments")
Teat <- dbGetQuery(con, "SELECT * FROM COLLEGE.dbo.Teachers")
Clas <- dbGetQuery(con, "SELECT * FROM COLLEGE.dbo.Classroom")

dbDisconnect(con)


df <- Reduce(inner_join, list(Clas, stu ))
arrange(df1, StudentId  )

df <- Reduce(inner_join, list(df, cur ))
arrange(df, CourseId  )

colnames(df)[8]<-"DepartmentId"
df
df <- Reduce(inner_join, list(df, Dep ))
arrange(df, DepartmentId )


colnames(df)[9]<-"TeacherID"
colnames(df)[4]<-"Student First name"
colnames(df)[5]<-"Student Last name"
colnames(df)[6]<-"Student Gender"

df <- Reduce(inner_join, list(df, Teat ))
arrange(df, TeacherID )
df
##############
## Q1. Count the number of students on each department¶
##############

  df %>% 
  select(DepartmentId,DepartmentName,StudentId) %>% distinct()%>% 
  group_by(DepartmentName) %>% summarise(count=n())
##############
## Q2. How many students have each course of the English department and the 
##     total number of students in the department?
##############

df %>%
  filter(DepartmentId == 01) %>%
  select(DepartmentId,DepartmentName,StudentId,CourseName) %>%
  group_by(CourseName) %>% summarise(count=n_distinct(StudentId))


df %>%
  filter(DepartmentId == 01) %>%
  select(DepartmentId,DepartmentName,StudentId,CourseName) %>%
  group_by(DepartmentName) %>% summarise(count=n_distinct(StudentId))
 
##############
## Q3. How many small (<22 students) and large (22+ students) classrooms are 
##     needed for the Science department?
##############
df4<-df %>% 
filter(DepartmentId == 02) %>% select(StudentId, CourseName) %>%
group_by(CourseName) %>% summarise(count=n()) %>%
mutate(Course_Size = ifelse(count >= 22,'BIG','SMALL')) %>%
group_by(Course_Size) %>% summarise(count=n()) 
df4
  



##############
## Q4. A feminist student claims that there are more male than female in the 
##     College. Justify if the argument is correct
##############
stu %>% 
  group_by(Gender) %>% summarise(count=n())

##############
## Q5. For which courses the percentage of male/female students is over 70%?
##############
  df %>%
    select(CourseName,StudentId,`Student Gender`) %>%
    mutate( Male_student= ifelse(`Student Gender` == " M",1,0)) %>%
    group_by(CourseName) %>% 
    summarise(Male_student=sum(Male_student)/n()*100) %>%
    filter(Male_student>=70)
  df %>%
    select(CourseName,StudentId,`Student Gender`) %>%
    mutate( Female_student= ifelse(`Student Gender` == " F",1,0)) %>%
    group_by(CourseName) %>% 
    summarise(Female_student=sum(Female_student)/n()*100) %>%
    filter(Female_student>=70)
    
   
  
##############
## Q6. For each department, how many students passed with a grades over 80?
##############
  df %>%
  select(DepartmentId,CourseName,DepartmentName,StudentId,degree) %>%
  filter(degree >=80)%>% 
  group_by(DepartmentId) %>% summarise(count=n_distinct(StudentId))


    

##############
## Q7. For each department, how many students passed with a grades under 60?
##############
  df %>%
    select(DepartmentId,DepartmentName,StudentId,degree) %>%
    filter(degree <=60)%>% 
    group_by(DepartmentName) %>% summarise(count=n_distinct(StudentId))

##############
## Q8. Rate the teachers by their average student's grades (in descending order).
##############
  colnames(df)[11]<-"Teacher First name"
  colnames(df)[12]<-"Teacher Last name"
  colnames(df)[13]<-"Teacher Gender"
df%>% 
  select(degree,TeacherID,`Teacher First name`,`Teacher Last name`)%>% 
  group_by(`Teacher First name`,`Teacher Last name`) %>% 
  summarise(degree=mean(degree))%>%arrange(desc(degree))

##############
## Q9. Create a dataframe showing the courses, departments they are associated with, 
##     the teacher in each course, and the number of students enrolled in the course 
##     (for each course, department and teacher show the names).
##############
  df_q9<-df%>%
    select(CourseName,DepartmentName,`Teacher First name`,`Teacher Last name`,StudentId)%>%
    group_by(CourseName,DepartmentName,`Teacher First name`,`Teacher Last name`) %>% 
   summarise(count=n_distinct(StudentId))
  df_q9


##############
## Q10. Create a dataframe showing the students, the number of courses they take, 
##      the average of the grades per class, and their overall average (for each student 
##      show the student name).
##############
  library(tidyr)
 
  df_q10<- df %>%
    group_by(StudentId,DepartmentId) %>% 
    mutate(avg=mean(degree)) %>%
    group_by(StudentId) %>% 
    mutate(total=mean(degree), courses=n()) %>%
    select(StudentId,DepartmentName,`Student First name`,`Student Last name`, avg, total, courses) %>%
    distinct() %>%
    arrange(desc(StudentId)) 
  df_q10<-pivot_wider(df_q10, names_from = DepartmentName, values_from = avg)
  df_q10
