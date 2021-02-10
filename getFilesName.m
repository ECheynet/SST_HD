function  [filename] = getFilesName(url)

indMin = 57;

try
    str = urlread(url);
    txt = regexprep(str,'<script.*?/script>','');
    txt = regexprep(txt,'<style.*?/style>','');
    txt = regexprep(txt,'<.*?>','');
    idx    = strfind(txt, '.nc');
    if ~isempty(idx)
        clear filename
        for ii=1:numel(idx)
            filename{ii} = [strtrim(txt(idx(ii)-indMin:idx(ii)-1)),'.nc'];
        end
        filename  = unique(filename(:));
    end
catch exception
    fprintf([url1,' not found \n'])
end

