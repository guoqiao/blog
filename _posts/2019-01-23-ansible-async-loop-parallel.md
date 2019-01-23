---
layout: post
title:  "Ansible task with async loop in parallel"
date:   2019-01-23 00:00:00 +1200
categories: posts
---

Example playbook 1:

    - hosts: localhost
      gather_facts: no
      tasks:
        - name: sleep 10s
          command: "sleep 10"
          loop: "{{range(3)|list}}"
          async: 33
          poll: 1
          register: async_loop

        - debug: var=async_loop


Output:

    Wednesday 23 January 2019  13:14:26 +1300 (0:00:00.032)       0:00:33.328 ***** 
    =============================================================================== 
    command ---------------------------------------------------------------- 33.18s
    debug ------------------------------------------------------------------- 0.03s
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
    total ------------------------------------------------------------------ 33.22s

Tasks finished in serial, not in parallel, with async 33 and poll 1.

Example playbook:


    - hosts: localhost
      gather_facts: no
      tasks:
        - name: sleep 10s
          command: "sleep 10"
          loop: "{{range(3)|list}}"
          async: 11
          poll: 0
          register: async_loop

        - debug: var=async_loop

        - name: wait
          async_status:
            jid: "{{item.ansible_job_id}}"
            mode: status
          retries: 11
          delay: 1
          loop: "{{async_loop.results}}"
          register: async_loop_jobs
          until: async_loop_jobs.finished

        - debug: var=async_loop_jobs


Tasks finished in 11s, which prove they were running in parallel:


    =============================================================================== 
    async_status ----------------------------------------------------------- 10.61s
    command ----------------------------------------------------------------- 0.66s
    debug ------------------------------------------------------------------- 0.03s
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
    total ------------------------------------------------------------------ 11.30s

Our task takes 10s to finish, so both the `async` value and `retries * delay` value
must be longer then 10s(I set to 11s in this case), otherwise task can not finish.

Debug output for `async_loop`:


   "async_loop": {
        "changed": true,
        "msg": "All items completed",
        "results": [
            {
                "_ansible_ignore_errors": null,
                "_ansible_item_label": 0,
                "_ansible_item_result": true,
                "_ansible_no_log": false,
                "_ansible_parsed": true,
                "ansible_job_id": "17279860874.14305",
                "changed": true,
                "failed": false,
                "finished": 0,
                "item": 0,
                "results_file": "/home/joeg/.ansible_async/17279860874.14305",
                "started": 1
            },
            {
                "_ansible_ignore_errors": null,
                "_ansible_item_label": 1,
                "_ansible_item_result": true,
                "_ansible_no_log": false,
                "_ansible_parsed": true,
                "ansible_job_id": "444102527227.14342",
                "changed": true,
                "failed": false,
                "finished": 0,
                "item": 1,
                "results_file": "/home/joeg/.ansible_async/444102527227.14342",
                "started": 1
            },
            {
                "_ansible_ignore_errors": null,
                "_ansible_item_label": 2,
                "_ansible_item_result": true,
                "_ansible_no_log": false,
                "_ansible_parsed": true,
                "ansible_job_id": "740500813639.14366",
                "changed": true,
                "failed": false,
                "finished": 0,
                "item": 2,
                "results_file": "/home/joeg/.ansible_async/740500813639.14366",
                "started": 1
            }
        ]
    }



Debug output for async_loop_jobs:


    "async_loop_jobs": {
        "changed": true,
        "msg": "All items completed",
        "results": [
            {
                "_ansible_ignore_errors": null,
                "_ansible_item_label": {
                    "_ansible_ignore_errors": null,
                    "_ansible_item_label": 0,
                    "_ansible_item_result": true,
                    "_ansible_no_log": false,
                    "_ansible_parsed": true,
                    "ansible_job_id": "817498908677.17174",
                    "changed": true,
                    "failed": false,
                    "finished": 0,
                    "item": 0,
                    "results_file": "/home/joeg/.ansible_async/817498908677.17174",
                    "started": 1
                },
                "_ansible_item_result": true,
                "_ansible_no_log": false,
                "_ansible_parsed": true,
                "ansible_job_id": "817498908677.17174",
                "attempts": 11,
                "changed": true,
                "cmd": [
                    "sleep",
                    "10"
                ],
                "delta": "0:00:11.002691",
                "end": "2019-01-23 12:51:27.991035",
                "failed": false,
                "finished": 1,
                "invocation": {
                    "module_args": {
                        "_raw_params": "sleep 10",
                        "_uses_shell": false,
                        "argv": null,
                        "chdir": null,
                        "creates": null,
                        "executable": null,
                        "removes": null,
                        "stdin": null,
                        "stdin_add_newline": true,
                        "warn": true
                    }
                },
                "item": {
                    "_ansible_ignore_errors": null,
                    "_ansible_item_label": 0,
                    "_ansible_item_result": true,
                    "_ansible_no_log": false,
                    "_ansible_parsed": true,
                    "ansible_job_id": "817498908677.17174",
                    "changed": true,
                    "failed": false,
                    "finished": 0,
                    "item": 0,
                    "results_file": "/home/joeg/.ansible_async/817498908677.17174",
                    "started": 1
                },
                "rc": 0,
                "start": "2019-01-23 12:51:16.988344",
                "stderr": "",
                "stderr_lines": [],
                "stdout": "",
                "stdout_lines": []
            },
            {
                "_ansible_ignore_errors": null,
                "_ansible_item_label": {
                    "_ansible_ignore_errors": null,
                    "_ansible_item_label": 1,
                    "_ansible_item_result": true,
                    "_ansible_no_log": false,
                    "_ansible_parsed": true,
                    "ansible_job_id": "180287881121.17198",
                    "changed": true,
                    "failed": false,
                    "finished": 0,
                    "item": 1,
                    "results_file": "/home/joeg/.ansible_async/180287881121.17198",
                    "started": 1
                },
                "_ansible_item_result": true,
                "_ansible_no_log": false,
                "_ansible_parsed": true,
                "ansible_job_id": "180287881121.17198",
                "attempts": 1,
                "changed": true,
                "cmd": [
                    "sleep",
                    "10"
                ],
                "delta": "0:00:10.001822",
                "end": "2019-01-23 12:51:27.141003",
                "failed": false,
                "finished": 1,
                "invocation": {
                    "module_args": {
                        "_raw_params": "sleep 10",
                        "_uses_shell": false,
                        "argv": null,
                        "chdir": null,
                        "creates": null,
                        "executable": null,
                        "removes": null,
                        "stdin": null,
                        "stdin_add_newline": true,
                        "warn": true
                    }
                },
                "item": {
                    "_ansible_ignore_errors": null,
                    "_ansible_item_label": 1,
                    "_ansible_item_result": true,
                    "_ansible_no_log": false,
                    "_ansible_parsed": true,
                    "ansible_job_id": "180287881121.17198",
                    "changed": true,
                    "failed": false,
                    "finished": 0,
                    "item": 1,
                    "results_file": "/home/joeg/.ansible_async/180287881121.17198",
                    "started": 1
                },
                "rc": 0,
                "start": "2019-01-23 12:51:17.139181",
                "stderr": "",
                "stderr_lines": [],
                "stdout": "",
                "stdout_lines": []
            },
            {
                "_ansible_ignore_errors": null,
                "_ansible_item_label": {
                    "_ansible_ignore_errors": null,
                    "_ansible_item_label": 2,
                    "_ansible_item_result": true,
                    "_ansible_no_log": false,
                    "_ansible_parsed": true,
                    "ansible_job_id": "570728132685.17222",
                    "changed": true,
                    "failed": false,
                    "finished": 0,
                    "item": 2,
                    "results_file": "/home/joeg/.ansible_async/570728132685.17222",
                    "started": 1
                },
                "_ansible_item_result": true,
                "_ansible_no_log": false,
                "_ansible_parsed": true,
                "ansible_job_id": "570728132685.17222",
                "attempts": 1,
                "changed": true,
                "cmd": [
                    "sleep",
                    "10"
                ],
                "delta": "0:00:10.002334",
                "end": "2019-01-23 12:51:27.290581",
                "failed": false,
                "finished": 1,
                "invocation": {
                    "module_args": {
                        "_raw_params": "sleep 10",
                        "_uses_shell": false,
                        "argv": null,
                        "chdir": null,
                        "creates": null,
                        "executable": null,
                        "removes": null,
                        "stdin": null,
                        "stdin_add_newline": true,
                        "warn": true
                    }
                },
                "item": {
                    "_ansible_ignore_errors": null,
                    "_ansible_item_label": 2,
                    "_ansible_item_result": true,
                    "_ansible_no_log": false,
                    "_ansible_parsed": true,
                    "ansible_job_id": "570728132685.17222",
                    "changed": true,
                    "failed": false,
                    "finished": 0,
                    "item": 2,
                    "results_file": "/home/joeg/.ansible_async/570728132685.17222",
                    "started": 1
                },
                "rc": 0,
                "start": "2019-01-23 12:51:17.288247",
                "stderr": "",
                "stderr_lines": [],
                "stdout": "",
                "stdout_lines": []
            }
        ]
    }
