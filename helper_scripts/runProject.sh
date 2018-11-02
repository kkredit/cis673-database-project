#!/bin/bash
echo exit | rlwrap sqlplus $USER@orcl/YOUR_ORACLE_PW @project.sql
