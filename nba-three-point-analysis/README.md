# NBA Three point scoring analysis

**Tools:** MongoDB, Studio 3T

MongoDB data analysis project completed for Data Management Fundamentals at Carnegie Mellon University.

### Project Files

- View Analysis Report
- View MongoDB Queries

## Analysis

Analyzed NBA game and player data to evaluate how the relative importance of three point field goals changed between the 1990s and 2000s.

I defined the importance of three point shooting as the percentage of total points scored from three point field goals and used MongoDB aggregation pipelines to calculate and compare this metric across the two decades.

**Key finding:** Three point field goals accounted for approximately 12.08% of total scoring in the 1990s and 17.45% in the 2000s, representing roughly a 45% relative increase.

## MongoDB Techniques

- Aggregation pipelines
- `$match` for date filtering
- `$unwind` for nested arrays
- `$group` for aggregation
- `$project` for calculated fields
- Date range filtering
- Analysis of nested document data
