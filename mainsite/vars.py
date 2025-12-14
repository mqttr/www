from os import environ

def global_vars(_):
    DOMAIN = environ.get('DOMAIN', 'example.com')
    return {
        'DOMAIN': DOMAIN,
        'EMAIL': {
            'SUFFIX': f'@{DOMAIN}',
            'CONTACT': f'contact@{DOMAIN}',
        },
        'LINK': {
            'GITHUB': r'https://github.com/mqttr',
            'LINKED_IN': r'https://www.linkedin.com/in/matthew-roland/',
        },
    }

