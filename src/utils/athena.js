import { Athena } from '@aws-sdk/client-athena';
import AthenaQuery from '@classmethod/athena-query';

const athena = new Athena({});
const athenaQuery = new AthenaQuery(athena);

export { athenaQuery };
