/// <reference types="cypress" />

it('list and retrieve jaeger traces', () => {

    const testService = 'redis';
    // Check application availability though the UI
    cy.visit('/search?end=3669306189365000&limit=20&lookback=1h&maxDuration&minDuration&service=' + testService + '&start=0').then(() => {

        // Ensure page contains Traces in an H2 tag
        cy.contains('h2', 'Traces');

        let traceIDLink = '';
        // Get <a> tag link of class "ResultItemTitle--item ub-flex-auto"
        cy.get('a.ResultItemTitle--item.ub-flex-auto').then((href) => {
            traceIDLink = href[0].href;
            // Get traceIDLink trace id after last slash
            const traceID = traceIDLink.substring(traceIDLink.lastIndexOf('/') + 1, traceIDLink.length);

            // Get trace info through API
            cy.request({
                method: 'GET',
                url: '/api/traces/' + traceID
            }).then((response) => {
                expect(response.status).to.eq(200);
                expect(response.body.data[0].traceID).to.eq(traceID);
            });
        })
    });
});
