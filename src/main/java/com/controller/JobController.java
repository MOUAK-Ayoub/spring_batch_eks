package com.controller;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobExecution;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

@RestController
@RequestMapping("/jobs")
public class JobController {

    @Autowired
    JobLauncher jobLauncher;

    @Autowired
    Job jobCsv;


    @GetMapping("/jobCsv")
    public void handle() throws Exception{

       JobParameters jobParameters = new JobParametersBuilder()
               .addDate("date", new Date())
                .toJobParameters();

        JobExecution execution = jobLauncher.run(jobCsv, jobParameters);
        System.out.println("Completion Status : " + execution.getStatus());

    }
}
