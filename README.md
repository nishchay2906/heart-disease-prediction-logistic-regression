# Heart failure survival analysis

An R coursework project predicting the `DEATH_EVENT` flag in the bundled heart failure clinical records. The script fits logistic regression and random-forest models and reports held-out classification results. The `time` follow-up field is excluded from the predictors.

## Run

In R, install the required packages.

```r
install.packages(c("readr", "corrplot", "randomForest", "rsample", "caret", "ranger", "pROC"))
```

From the repository root, run:

```sh
Rscript "project2 - without time.R"
```

To use a CSV with the same schema from another location, pass its path as the first argument. A [Tableau packaged workbook](project_visualize.twbx) is included for interactive exploration. These models are coursework and have no clinical validation.
