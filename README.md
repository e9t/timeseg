# timeseg

Algorithm and code for segmenting sequential numerical data based on its characteristics.<br>
For more information visit: http://dmlab.snu.ac.kr/u/lucypark#data-summarization


### Configuration

1. Input experimental settings

    Create a settings file as below and input appropriate values.

        $ cp settings.m.sample settings.m

1. Format input data files

    Input data files should be formatted as below:

    <table>
    <thead>
        <tr>
            <td>datetime</td>
            <td>row_id_1</td>
            <td>row_id_2</td>
            <td>given_partition</td>
            <td>data_value</td>
        </tr>
    </thead>
    <tbody>
        <tr><td>2009-11-15 04:08:01</td><td>A</td><td>1</td><td>a</td><td>0.613631</td></tr>
        <tr><td>2009-11-15 04:08:02</td><td>A</td><td>1</td><td>a</td><td>0.613632</td></tr>
        <tr><td>2009-11-15 04:08:03</td><td>A</td><td>1</td><td>a</td><td>0.613630</td></tr>
        <tr><td>...</td><td>...</td><td>...</td><td>...</td><td>...</td></tr>
    </tbody>
    </table>

### Run

In Matlab Command Window:

    >> exe

### License

[Apache License v2.0](http://www.apache.org/licenses/LICENSE-2.0)

### Acknowledgements

- Bruno Luong, [Free-knot spline approximation](http://www.mathworks.co.kr/matlabcentral/fileexchange/25872-free-knot-spline-approximation), Matlab Central, 2009.
